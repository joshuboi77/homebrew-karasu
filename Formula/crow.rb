class Crow < Formula
  desc "None"
  homepage "None"
  version "0.1.5"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.5/crow-darwin-arm64.tar.gz"
      sha256 "c2788789e49af8f93fcc061d577526cf82da0e489dd8ad6456716a94eae9eb39"
    else
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.5/crow-darwin-amd64.tar.gz"
      sha256 "4c1610d5087e1ef5e99b8c46105f09920dcd7a0e495e28d3268e22cb4ecad3ca"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Crow/releases/download/v0.1.5/crow-linux-amd64.tar.gz"
    sha256 "3ce2c1ff71004b3ff194e91cde19e00863451db2a5d462866345a1bc57a784af"
  end

  def install
    # Install wrapper script from bin/ directory in tarball
    bin.install "bin/crow" => "crow"

    # Install Python package so wrapper script can import it
    # The wrapper script does "from crow.main import main" so package must be installed
    # Package source is included in the tarball, install from extracted source
    python3 = "python3.11"
    if File.exist?("pyproject.toml")
      # Install from pyproject.toml in the extracted tarball
      system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
    elsif File.exist?("setup.py")
      # Fallback for setup.py
      system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
    else
      # Try installing package name from bundled source
      package_dir = "crow"
      if Dir.exist?(package_dir)
        # Create a minimal setup.py if needed
        File.write("setup.py", "from setuptools import setup; setup(name='crow', version='0.1.5')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.1.5", shell_output("#{bin}/crow --version")
  end
end

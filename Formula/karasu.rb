class Karasu < Formula
  desc "None"
  homepage "None"
  version "0.3.3"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.3/karasu-darwin-arm64.tar.gz"
      sha256 "86b77e9b6453fc270bcf87d66066aa4a62ea58f948bae43ead8aff40714f1a5f"
    else
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.3/karasu-darwin-amd64.tar.gz"
      sha256 "60121f8972c143de37bf0084aacdd4633540cc63b8121f4f3fb4e4ef90017dfc"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.3/karasu-linux-amd64.tar.gz"
    sha256 "22fefdfd6ae9c79f964ab8a9aa56f57eff286b31593034253a3cfd8acd751e36"
  end

  def install
    # Install wrapper script from bin/ directory in tarball
    bin.install "bin/karasu" => "karasu"

    # Install Python package so wrapper script can import it
    # The wrapper script does "from karasu.main import main" so package must be installed
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
      package_dir = "karasu"
      if Dir.exist?(package_dir)
        # Create a minimal setup.py if needed
        File.write("setup.py", "from setuptools import setup; setup(name='karasu', version='0.3.3')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.3.3", shell_output("#{bin}/karasu --version")
  end
end

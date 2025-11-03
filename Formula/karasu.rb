class Karasu < Formula
  desc "None"
  homepage "None"
  version "0.2.0"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.2.0/karasu-darwin-arm64.tar.gz"
      sha256 "ff55f4f75865a7b7f123c1dde74eda20c6600cb4968001350368247067fd9c30"
    else
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.2.0/karasu-darwin-amd64.tar.gz"
      sha256 "c7520937ec656009680f55eb8936e9e3ea091d1bcf59600bee17a548c67e999a"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Karasu/releases/download/v0.2.0/karasu-linux-amd64.tar.gz"
    sha256 "b53ca053249afcffc8816c7c0c007f5d87342be6470cfc15a4566ed04cbd816f"
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
        File.write("setup.py", "from setuptools import setup; setup(name='karasu', version='0.2.0')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.2.0", shell_output("#{bin}/karasu --version")
  end
end

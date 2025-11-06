class Karasu < Formula
  desc "None"
  homepage "None"
  version "0.3.0"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.0/karasu-darwin-arm64.tar.gz"
      sha256 "ad24670f90b3b446d514e3eda205cf12609cac0e3e06d0910e81693cc19fdf94"
    else
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.0/karasu-darwin-amd64.tar.gz"
      sha256 "2bef184c0ddc7a4fd622faf80da818ec43c6c6cfbf0d1247fc9c2d5e5fdb8ebf"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.0/karasu-linux-amd64.tar.gz"
    sha256 "878da9c51e4855adae86d753449dc3fb7a26a5389333629cf2d41712426a19a8"
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
        File.write("setup.py", "from setuptools import setup; setup(name='karasu', version='0.3.0')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.3.0", shell_output("#{bin}/karasu --version")
  end
end

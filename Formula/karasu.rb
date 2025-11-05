class Karasu < Formula
  desc "None"
  homepage "None"
  version "0.2.1"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.2.1/karasu-darwin-arm64.tar.gz"
      sha256 "a47ccf1076241ac6161155806f1f579e69143b4847dd50fd6152e851fc3b9c13"
    else
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.2.1/karasu-darwin-amd64.tar.gz"
      sha256 "6caf38f2ef201392cdc9beda8d7600d0606bb23149ee00a1758f53b1b82e6840"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Karasu/releases/download/v0.2.1/karasu-linux-amd64.tar.gz"
    sha256 "cdcfa103d453f7b790b8b2f0b6329dced16a1de712149e1eff56d5e099718297"
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
        File.write("setup.py", "from setuptools import setup; setup(name='karasu', version='0.2.1')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.2.1", shell_output("#{bin}/karasu --version")
  end
end

class Karasu < Formula
  desc "None"
  homepage "None"
  version "0.3.2"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.2/karasu-darwin-arm64.tar.gz"
      sha256 "88710895e060ff446bd6fbc0b61092e70dbc1198e6a5206fb0d889d84234c2d1"
    else
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.2/karasu-darwin-amd64.tar.gz"
      sha256 "446c629ff735fd51d771357c52a8db2412c7e4db451677035ce0660efbbca1e2"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.2/karasu-linux-amd64.tar.gz"
    sha256 "01fd97c4e9185d4fc337424feb776fae4708fd3ad3d8583a735e321dd25e59ea"
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
        File.write("setup.py", "from setuptools import setup; setup(name='karasu', version='0.3.2')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.3.2", shell_output("#{bin}/karasu --version")
  end
end

class Crow < Formula
  desc "None"
  homepage "None"
  version "0.1.4"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.4/crow-darwin-arm64.tar.gz"
      sha256 "148af0e56c9b103aa97083d5d1af6dd3fe5cc5294c31da52d36e62bf355f1a37"
    else
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.4/crow-darwin-amd64.tar.gz"
      sha256 "b39b71f4b81be75d216c1d2f1761a6e71e099d580893170a370f5c2a302b6772"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Crow/releases/download/v0.1.4/crow-linux-amd64.tar.gz"
    sha256 "183d410008fd3a6ed8fb29d8b0da1728665a73c92a8892b49cc76ec46cc88a66"
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
        File.write("setup.py", "from setuptools import setup; setup(name='crow', version='0.1.4')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.1.4", shell_output("#{bin}/crow --version")
  end
end

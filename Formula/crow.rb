class Crow < Formula
  desc "None"
  homepage "None"
  version "0.1.1"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.1/crow-darwin-arm64.tar.gz"
      sha256 "8bcfcf53f7529ad1eded2e64a1b9a06d9cca6f6b8a9a75840b072ba282ac8b42"
    else
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.1/crow-darwin-amd64.tar.gz"
      sha256 "fc6e03368b41b7b08f8bf87679ee7fd3c7a053dacd9e00d9ca55d69b76785324"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Crow/releases/download/v0.1.1/crow-linux-amd64.tar.gz"
    sha256 "b05c1942740954a717e6030cc57351cb7ca07a126e458b8e4d0c6d5099ce893d"
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
        File.write("setup.py", "from setuptools import setup; setup(name='crow', version='0.1.1')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/crow --version")
  end
end

class Crow < Formula
  desc "None"
  homepage "None"
  version "0.1.0"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.0/crow-darwin-arm64.tar.gz"
      sha256 "ea2cefdd4a7da99721e3b00390e6f754c8ed59db40f9fb99e6d784a75c0ca21d"
    else
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.0/crow-darwin-amd64.tar.gz"
      sha256 "add6918144965f1532a50edcde10c2f8fa8c6bcb1ccaa19935aa149c304c1702"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Crow/releases/download/v0.1.0/crow-linux-amd64.tar.gz"
    sha256 "c412f1b2bf7fc5df623803093215a85b1d4dd7ea1dbca5e690291879892e06b1"
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
        File.write("setup.py", "from setuptools import setup; setup(name='crow', version='0.1.0')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/crow --version")
  end
end

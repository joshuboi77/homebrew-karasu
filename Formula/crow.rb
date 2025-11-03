class Crow < Formula
  desc "None"
  homepage "None"
  version "0.1.3"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.3/crow-darwin-arm64.tar.gz"
      sha256 "4ad8c335898023d1d2deff6cbc2970b6f9b9e2bbc99f3e7717818a6eb05d92c1"
    else
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.3/crow-darwin-amd64.tar.gz"
      sha256 "8237e8997ad5a2ed3465647cc23ace84814d2e3f46f5fb505d8402563745d3cc"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Crow/releases/download/v0.1.3/crow-linux-amd64.tar.gz"
    sha256 "006c0b7eec9c3a0176bb0cdca05e5d6110c57c25dfed97bfbbdc79a50d5d364e"
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
        File.write("setup.py", "from setuptools import setup; setup(name='crow', version='0.1.3')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.1.3", shell_output("#{bin}/crow --version")
  end
end

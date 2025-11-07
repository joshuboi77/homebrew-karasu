class Karasu < Formula
  desc "None"
  homepage "None"
  version "0.3.1"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.1/karasu-darwin-arm64.tar.gz"
      sha256 "be3ab541291c284dd63cde32c96ccde747814241e20161be7b0994160a357fd9"
    else
      url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.1/karasu-darwin-amd64.tar.gz"
      sha256 "6d0ecd5854460255eedd607971d0dd0635d9373501c35a42d81d0a43044e08e6"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Karasu/releases/download/v0.3.1/karasu-linux-amd64.tar.gz"
    sha256 "d57015567d815ade349894b3c2e53990554a4f5e73c8cee7c60bc850864b6c30"
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
        File.write("setup.py", "from setuptools import setup; setup(name='karasu', version='0.3.1')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.3.1", shell_output("#{bin}/karasu --version")
  end
end

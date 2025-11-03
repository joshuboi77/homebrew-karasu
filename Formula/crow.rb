class crow < Formula
  desc "None"
  homepage "None"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.0/crow-darwin-arm64.tar.gz"
      sha256 "f263a6a82bd0bd13fbe3ee3cdf8271efdc56f681d4919f5d21e6f5b0c9d45276"
    else
      url "https://github.com/joshuboi77/Crow/releases/download/v0.1.0/crow-darwin-amd64.tar.gz"
      sha256 "4a2c5ca9bd11c209ad609b3a2f6acd091ead24a1526560e81f98ea6605209459"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Crow/releases/download/v0.1.0/crow-linux-amd64.tar.gz"
    sha256 "b4f0b8097a752d05ba10a1669a49cff46514029b63d0a70a0925e5b3a80e9d3e"
  end

  def install
    bin.install "crow"
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/crow --version")
  end
end

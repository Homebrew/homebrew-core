class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_18.tar.gz"
  sha256 "22a195567e3493e7c9ca8bf8fa2339f4ffc876384849ac8a417ff4b919607e7b"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a5b9fefb7c4839d8c27bade2699cc10a567224b1c8eed3138cec4a8baa6766d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0378e13eeb77a7f96d73e52043cd76cd7b17f9b4a1066257165dbb3128a6be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed8c211d3e313b17d1fcf588c0e370b34acff7c76dcd3cb5b0ab43357088759"
    sha256 cellar: :any_skip_relocation, sonoma:        "013a1a1baf3128725386ad3828dfd47f1d5daf24ca923ea71b863a40c367b169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c600097da4cf8be54ce859cf65b060c8acb50f9b8d5e470e4fa99263352744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bfa9ba2618027d9e2a95148008f77151521014fcc992e28799eda4299b9f63d"
  end

  def install
    arch = if !build.bottle?
      "native"
    elsif Hardware::CPU.arm? && OS.mac?
      "apple-silicon"
    elsif Hardware::CPU.arm?
      "armv8"
    elsif OS.mac? && MacOS.version.requires_sse41?
      "x86-64-sse41-popcnt"
    else
      "x86-64-ssse3"
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system bin/"stockfish", "go", "depth", "20"
  end
end

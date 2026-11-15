class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  license all_of: ["GPL-3.0-only", "CC0-1.0"]
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  stable do
    url "https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_19.tar.gz"
    sha256 "519b653d0d1ffb96531d982ccbe5c6a19425e8388e0e3c2f70f34b424ab32d76"

    resource "network" do
      url "https://tests.stockfishchess.org/api/nn/nn-1a298aa575a0.nnue"
      version "1a298aa575a0"
      sha256 "1a298aa575a085434d29027978dc36867fe9c5bcea9376654b7a8eba1e52dfc2"

      livecheck do
        # For each update, consult src/evaluate.h for updated network file name
        url "https://raw.githubusercontent.com/official-stockfish/Stockfish/refs/tags/sf_#{LATEST_VERSION}/src/evaluate.h"
        regex(/EvalFileDefaultName\s+"nn-(\h{12})\.nnue"/i)
      end
    end
  end

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d8feeb40839678eacfd6a8afbc6d1b077ae4f690c0266f772ad48660a4ea85f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed9abf25a13559c8c171dd4956998da30e46be61c5eb1642f91686af8b7cf60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17f082147af64d5b5f53cec7f368b39e2716cfe38556f890146510e2557e44ac"
    sha256 cellar: :any,                 arm64_linux:       "beefac0079e9ac5bc76b3791f7c70a4ac5d6b8c2d8a06a60da37f4f21f335aed"
    sha256 cellar: :any,                 x86_64_linux:      "fd5c4e86f30f72837e1a65b01cd40ca029a1ec3c6d849a89d772965fc4be11c5"
  end

  deny_network_access!

  def fetch
    if build.head?
      system "make", "-C", "src", "net"
    else
      resource("network").stage "src"
    end
  end

  def install
    arch = if !build.bottle?
      "native"
    elsif Hardware::CPU.arm? && OS.mac?
      "apple-silicon"
    elsif Hardware::CPU.arm?
      "armv8"
    else
      "x86-64-ssse3"
    end

    args = %W[
      CXX=#{ENV.cxx}
      ARCH=#{arch}
      PREFIX=#{prefix}
    ]

    system "make", "-C", "src", "profile-build", *args
    system "make", "-C", "src", "install", *args
  end

  test do
    system bin/"stockfish", "go", "depth", "20"
  end
end

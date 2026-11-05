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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d3d7d7e4412f4326f1393aadfa8476dadd265072e976a53a63c284342ce65ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cff11c467e56926956e5042db854523ea3a8dae6625db4fe58215b911bf2cb6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8fa31b8efc0156a64877eeb79c93386bf063520c27b5e51bf97eb28ff6846e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9af19bcd8571d9d28b878191839a147914933f82195f27c053444645f05d5046"
    sha256 cellar: :any,                 arm64_linux:       "ef719fa41ee73e2f5ae3f556791745218543e53be25242a7e66e7a4cfc7307c5"
    sha256 cellar: :any,                 x86_64_linux:      "2f2fa24960bb944c41f4b09503c36dffd7495206201cf1dabe7606691a96d31d"
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

    build_type = build.bottle? ? "build" : "profile-build"

    args = %W[
      ARCH=#{arch}
      PREFIX=#{prefix}
    ]

    cd "src" do
      system "make", build_type, *args
      system "make", "install", *args
    end
  end

  test do
    system bin/"stockfish", "go", "depth", "20"
  end
end

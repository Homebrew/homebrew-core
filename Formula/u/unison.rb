class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/refs/tags/v2.53.4.tar.gz"
  sha256 "d19e4293013581dbc4d149aef89b34c76221efcbd873c7aa5193de489addb85a"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "548aceef769afb14ab74b7c55d42bcd25d50608213a44dba5db1f31402e9bae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c11023084ca2bded2a4419c2f6d5f87fc92ab33c8dc03d35f0d29db7797c4259"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f74810191e23a05306cd31a06eaf910105f35e272f608ccc827fd927b6190ca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdaea2ae64542070f01ba80b62ea53d1fc8ec28e0ea469a407dc87bcad0b1c5b"
    sha256 cellar: :any_skip_relocation, ventura:        "04ef0db4f211c7683a9d2618650bc7c1db5cf4d86b16724c3f6c7ff1d8835854"
    sha256 cellar: :any_skip_relocation, monterey:       "5660ee6722103c7df3a9391aa405672591c2264e47d8a2488268abce2e01ff7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cfafebe4d13d8d8b3f02800762c79f0cd488ad6baa05c4288219b8cc5b6c6e0"
  end

  depends_on "ocaml" => :build

  def install
    system "make", "src/unison"
    bin.install "src/unison"
    # unison-fsmonitor is built just for Linux targets
    if OS.linux?
      system "make", "src/unison-fsmonitor"
      bin.install "src/unison-fsmonitor"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end

class Wumpus < Formula
  desc "Exact clone of the ancient BASIC Hunt the Wumpus game"
  homepage "http://www.catb.org/~esr/wumpus/"
  url "http://www.catb.org/~esr/wumpus/wumpus-1.10.tar.gz"
  sha256 "aa059e163b4f516580b83931ae29fbd5796302e854da283b85cc7fc887677d7c"
  license "BSD-2-Clause"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e06701869c21c2e18ef131477db256df8f876160dcc67eb17d216546f658cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "418502a95f4ba4577d30f5e48699cb2c434b64cb63bc34bda4d28f8525d3b3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb4c854f4a9ca5952140e121567c502f46af0e6ced51b8916bc9fb3147b9a085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37eece81c8fdacbd791f7f8365364e2de6630c5ed93bbaffb9624c347b53f8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a59c6e421b3d461bfcfdd91b85fcba05a205df3eca4eaf0e0611f83e749f8fcb"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1866abf23ccf0920311248107cfacd4da35d2081903ade4bde1c7879c4f711"
    sha256 cellar: :any_skip_relocation, monterey:       "1ceb6248fd61580bb9c99ab1833503cad88c84daf4816771cfdc96f087755fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f9a87dd8a82fc0bf2969cedfca5dd336e0e3575d6792bf3d8e19e6f3506332"
  end

  head do
    url "https://gitlab.com/esr/wumpus.git", branch: "master"
    depends_on "asciidoctor" => :build
  end

  # checksum got changed and no response from upstream, https://gitlab.com/esr/wumpus/-/issues/2
  deprecate! date: "2025-09-12", because: :does_not_build
  disable! date: "2026-09-12", because: :does_not_build

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match("HUNT THE WUMPUS",
                 pipe_output(bin/"wumpus", "^C"))
  end
end

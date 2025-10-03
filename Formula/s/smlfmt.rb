class Smlfmt < Formula
  desc "Custom parser and code formatter for Standard ML"
  homepage "https://github.com/shwestrick/smlfmt"
  url "https://github.com/shwestrick/smlfmt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6517b0186518308d26f388d882af3b6106103a3ca3f00a4974e54fb526225df5"
  license "MIT"
  head "https://github.com/shwestrick/smlfmt.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90962a33b9f4c6ced5fe20c3f9d44e4a0757d028ed454cae1e47e6d9833830ad"
    sha256 cellar: :any,                 arm64_sequoia: "ca671852fb33a6c846046fc88e6ba48b80f18a2b41844bbb6f711c9ca6600e2b"
    sha256 cellar: :any,                 arm64_sonoma:  "4a4d72dd8bc6a5eb4cc96f5b8029163371f7a8d8bc8ca005a6a01f874f8b24d7"
    sha256 cellar: :any,                 arm64_ventura: "a69daa52e744e9fad8803348b5f29487de9d07fd1f4d7146402371e765c55da2"
    sha256 cellar: :any,                 sonoma:        "76372f8a0e174f68b5dadaaa5cc621fb5cc71ea212284333c9b26dfc3d3a3a36"
    sha256 cellar: :any,                 ventura:       "d64483f4b661c239a66377251e21db3c9194f9e5146e1bf0150994fd93c4f4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "215c5fe4dc87bb774faa139d50d6e794398d09f96e1f20da68d1ba58208de60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24cd0363e581e4721ee4717895fcd05cbe4cfeab264515bdcbb7d6bd905ee2f9"
  end

  depends_on "mlton" => :build
  depends_on "gmp"

  def install
    system "make"
    bin.install "smlfmt"
  end

  test do
    (testpath/"source.sml").write <<~EOS
      fun foo x =     10
      val x = 5 val y = 6
    EOS
    expected_output = <<~EOS
      fun foo x = 10
      val x = 5
      val y = 6
    EOS
    system bin/"smlfmt", "--force", "source.sml"
    assert_equal expected_output, (testpath/"source.sml").read
  end
end

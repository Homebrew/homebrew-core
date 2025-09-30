class Tal < Formula
  desc "Align line endings if they match"
  homepage "https://thomasjensen.com/software/tal/"
  url "https://thomasjensen.com/software/tal/tal-1.9.tar.gz"
  mirror "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/misc/tal/tal-1.9.tar.gz"
  sha256 "5d450cee7162c6939811bca945eb475e771efe5bd6a08b520661d91a6165bb4c"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?tal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a3aad8a5f10c8cee1e5b9dbfb673a6b05ff97774e5cb2f0f813b76c893b3e424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dd3c811b07d428e7beccf39eda7c3a0af73695f03188dfc7ea652472d492c794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94631ec0dafade563c1652e557981e5b4ed4f3583f3586bc9091be4d96c2b7b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "717e28a9ea9f325fd72962d66372a1e4edc3b27e81ea54a861f8c54dceea0a56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94237b7f329c30c17aed19d82bb18a790abf2abcbfc404a57ef9e237db4a0735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ca62e367e9b35b079d0419bc02c4baec570154a089337f4ffce87441e9ba7af"
    sha256 cellar: :any_skip_relocation, sonoma:         "beb5a6e9a3745345a2de1441503f9718428c27aca657c319a15615bdff1ed993"
    sha256 cellar: :any_skip_relocation, ventura:        "d586b3fdc04b4b8b8379249958cae1be5f1d15417b50aa8699a7c63ab99598c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b869e27ee13cb3e2ec83b0bb24a3dfc17b753ae94afa8e11d5e75943e8f1c132"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff2e907039f88888af6724c384e32b3191fd39097266bbdcf415faa3b9cc927f"
    sha256 cellar: :any_skip_relocation, catalina:       "1d2978734ee3f0c63efdd0acdff401014954c34ed709ed397348dc1f3f973b88"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "779b8afc3da3186f16ce41fd9d40257f24e01b80520b625ddcf848f636646357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568fa7d6db8a642d71501bd804351e281c512fa82f3c2757bc870e7e8d871ecd"
  end

  def install
    system "make", "tal"
    bin.install "tal"
    man1.install "tal.1"
  end

  test do
    (testpath/"test.c").write <<~C
      /***************************************************/
      /* some text and so on                    */
      /*       even more text                                   */
      /*       foo, bar. bar bar.                   */
      /***************************************************/
    C
    assert_equal <<~C, shell_output("#{bin}/tal -p 0 test.c")
      /***************************************************/
      /* some text and so on                             */
      /*       even more text                            */
      /*       foo, bar. bar bar.                        */
      /***************************************************/
    C
  end
end

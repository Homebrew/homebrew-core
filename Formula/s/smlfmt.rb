class Smlfmt < Formula
  desc "Custom parser and code formatter for Standard ML"
  homepage "https://github.com/shwestrick/smlfmt"
  url "https://github.com/shwestrick/smlfmt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ca957b3a72615d292443742a1b155d180d963e1c4e17d4d2644af4fb53be627f"
  license "MIT"
  head "https://github.com/shwestrick/smlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2329e3a4e23e56b1013035baaf9c9c1f157405aa2b07b853b982964c4a2f919d"
    sha256 cellar: :any,                 arm64_sonoma:   "36c764b23fb9b73301fcf0601c7b09ec340da7e9196ae447ea38fa3060bfb8ef"
    sha256 cellar: :any,                 arm64_ventura:  "868903facaf75ef62c7287e3cb00e2c2f2b6196c63329d0b79ce6e11c6a34ead"
    sha256 cellar: :any,                 arm64_monterey: "f445a8363987d090c4e699f4875e16d05c04f0debb27b15bc2fc34fd3dcc2049"
    sha256 cellar: :any,                 sonoma:         "a380f2a3f561e4a0f2c4c9a78caa9767d8f5585ed33dd6a49fd495dcf75f0323"
    sha256 cellar: :any,                 ventura:        "f40b271e4ea6a8d87e64a7776e1ba2d57cb0c0bd25d242ce8ed3d5bee74eb6fa"
    sha256 cellar: :any,                 monterey:       "cd0d919fc4a9557aedc0e2e6ef8e854b66b9daf5c956f66a45d38a30a815e635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1b92b3ef804bcf8cb98eed9d42550f9752ac31479328e53e7e2d74c86687ec3"
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

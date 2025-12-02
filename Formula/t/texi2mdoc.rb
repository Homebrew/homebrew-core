class Texi2mdoc < Formula
  desc "Convert Texinfo data to mdoc input"
  homepage "https://mandoc.bsd.lv/texi2mdoc/"
  url "https://mandoc.bsd.lv/texi2mdoc/snapshots/texi2mdoc-0.1.2.tgz"
  sha256 "7a45fd87c27cc8970a18db9ddddb2f09f18b8dd5152bf0ca377c3a5e7d304bfe"
  license "ISC"
  head "anoncvs@mandoc.bsd.lv:/cvs", using: :cvs

  livecheck do
    url "https://mandoc.bsd.lv/texi2mdoc/snapshots/"
    regex(/href=.*?texi2mdoc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5b041762001de978d115ff087c59982e554f06f6b83a92d1d35988d4e73ff7db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9a769b9b0c164d2f296ef48c04dfa683a0605dbf55e93f12c34c273b9ca6f90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10e2d836d65a262b58228fd05b6b09a9d069d2b889905b36a81239fd646aec7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6c15b6cfa57413d994f850c8e1175bbb2023859cbdfd8730b07795c543a40f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d24979a6eebabad2b16282ea9f5b1518a847c10874cd3fb0545c687a3569849f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a991a1ed6f69eeaec46e684c2d66c257d04ae6da8664aea9d0db3c8c24f1f97b"
    sha256 cellar: :any_skip_relocation, ventura:        "086e55b2a674e03d5ac3d53a5553823ad4b72c7062d43d9ae64e138bb2f96b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b2c1306839db292791ad1e6e89a0c723a9baaeeb5ca4dfcf8132d2b19646b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59a3fc35cc4cf7c00742287367c32d3aeb3945b95d10ec83581276efb86e3fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f155dfc278556137351b12849d598130decfbf64e824f99de7dda813a731051f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    share.install prefix/"man"
  end

  test do
    (testpath/"test.texi").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS

    output = shell_output("#{bin}/texi2mdoc #{testpath}/test.texi")
    expected_outputs = [/\.Nm\s+test/, /\.Sh\s+Hello World!/]
    expected_outputs.each do |expected|
      assert_match expected, output
    end
  end
end

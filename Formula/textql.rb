class Textql < Formula
  desc "Executes SQL across text files"
  homepage "https://github.com/dinedal/textql"
  url "https://github.com/dinedal/textql/archive/2.0.3.tar.gz"
  sha256 "1fc4e7db5748938c31fe650e882aec4088d9123d46284c6a6f0ed6e8ea487e48"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d33d111039e957631d3a77cd35413707b47e684638a2571e3719a17c0173b55d" => :catalina
    sha256 "b6d4fd5ee0a2d1758651f91c35e6bd40a832f0d997ec2a120268bfde03a48cfb" => :mojave
    sha256 "38cbf8cacc0dd7e29831c8c7fe9f0437473c164bee549defb8744d6ca3e53fcb" => :high_sierra
    sha256 "f7bcfcacbd0b3076037e4715dabd1d925ef52ec66a3018d7a0124d091a7711c5" => :sierra
    sha256 "9950b83cf4d7bf59d3bf54711a845ddcf27f31dd004150acce3b8011ca2874a5" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/dinedal/textql").install buildpath.children

    cd "src/github.com/dinedal/textql" do
      system "glide", "install"
      system "go", "build", "-ldflags", "-X main.VERSION=#{version}",
             "-o", bin/"textql", "./textql"
      man1.install "man/textql.1"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "3\n",
      pipe_output("#{bin}/textql -sql 'select count(*) from stdin'", "a\nb\nc\n")
  end
end

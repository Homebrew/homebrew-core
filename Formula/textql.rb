class Textql < Formula
  desc "Executes SQL across text files"
  homepage "https://github.com/dinedal/textql"
  url "https://github.com/dinedal/textql/archive/2.0.3.tar.gz"
  sha256 "1fc4e7db5748938c31fe650e882aec4088d9123d46284c6a6f0ed6e8ea487e48"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca2c7ba2e7d3b423cef6af90f705588346a365b226c6763fbd2041204426d645" => :high_sierra
    sha256 "c64e983a2230ae263258bb4bea4d9382efed77fa6934d1c32ae41304193b7b85" => :sierra
    sha256 "f958e30ce6df17f9dabddbb5a6a4af0d9d7690844983cfae8eb864ec2bdf0913" => :el_capitan
    sha256 "aed185329089c37638d1cf3aec6dbcf51180772f6f62d6b8fc74de733e664d6c" => :yosemite
    sha256 "5d31dc62316f04fea50b4fa1e75230e80a8c2c749c33e1f22aa74b26f26074f8" => :mavericks
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

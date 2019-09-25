class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.0.0.tar.gz"
  sha256 "31e6fceaa3ae51be7b93d308eb0b68c891277f904c17cf6496e51062f1655332"

  bottle do
    cellar :any_skip_relocation
    sha256 "850399f50dccd74a0b26b06110bcc2c350684113d43c4befc589cc184eb10254" => :mojave
    sha256 "f15b8866018349165cf08465902fc6de24b7ffa4207baa8aab4f1e4851933cbf" => :high_sierra
    sha256 "9b568c659828cf15eae198a7632a3ef6ca66fcad518541518ab3d380b1d39a07" => :sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/apache/openwhisk-cli"
    dir.install buildpath.children
    cd dir do
      system "go-bindata", "-pkg", "wski18n", "-o",
                           "wski18n/i18n_resources.go", "wski18n/resources"
      system "govendor", "sync"

      system "go", "build", "-o", bin/"wsk"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end

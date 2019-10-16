class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/v0.3.2.tar.gz"
  sha256 "359510cfea8af8f14de39d63f63cc5c765f681cca2c37f00174837d52c62cad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "83553c30a557b081201b4e28600f52b589bfd8fc640c8b57dc6086d3a450be15" => :catalina
    sha256 "0c453761279cdc6a995ae471841b2e8513215c3d30f4f448c3cf82f548376fa5" => :mojave
    sha256 "f9ea40f11e458e2bda259fa428a9f390d9a9efce1d7983f9325eda17b4655501" => :high_sierra
    sha256 "558f89d83bd23a28ef31a1d72f7749521f68ebf0d767a8cffb2c6b9311461e13" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    dir = buildpath/"src/github.com/akavel/up"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"up", "up.go"
      prefix.install_metafiles
    end
  end

  test do
    shell_output("#{bin}/up --debug 2&>1", 1)
    assert_predicate testpath/"up.debug", :exist?, "up.debug not found"
    assert_includes File.read(testpath/"up.debug"), "checking $SHELL"
  end
end

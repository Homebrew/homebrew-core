class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/v0.3.2.tar.gz"
  sha256 "359510cfea8af8f14de39d63f63cc5c765f681cca2c37f00174837d52c62cad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "05a4f4be50e78924d65b7711d41fe835f724db6543bb5400314edba8f3c9ca80" => :mojave
    sha256 "fdaf32376df28ef7231d4894f9ce7ce2eb3e4da25007ce82d341c98cef4aa31d" => :high_sierra
    sha256 "d2eb809466efe4f91b71a1bbdfd3c0e259865e231d3d4da0b40acec3e93d54ff" => :sierra
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

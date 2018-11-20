class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/v0.3.1.tar.gz"
  sha256 "4e423e2a97a9d4a45a89ab37a6ff6ea826d2849eae0ef8258346900189afc643"

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

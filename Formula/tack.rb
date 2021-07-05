class Tack < Formula
  desc "Sustainable static site generator"
  homepage "https://burningsoda.com/software/tack"
  url "https://burningsoda.com/software/tack/download/tack-1.2.0.tar.gz"
  sha256 "b67a8598f13e8581e27b5418195ec6f3452d8b65076fd972d4f6c64ace465477"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/roblillack/tack/commands.Version=v#{version}", *std_go_args
    man.mkpath
    man1.install "tack.1"
  end

  test do
    mkdir "content"
    mkdir "templates"
    (testpath/"content/default.yaml").write "who: World"
    (testpath/"templates/default.mustache").write "Hello {{who}}!"
    system "tack"
    assert_predicate testpath/"output/index.html", :exist?
    assert_equal "Hello World!", (testpath/"output/index.html").read.strip
  end
end

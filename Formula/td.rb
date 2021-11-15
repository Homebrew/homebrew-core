class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.4.2.tar.gz"
  sha256 "e85468dad3bf78c3fc32fc2ab53ef2d6bc28c3f9297410917af382a6d795574b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "183862b016182f09f43d0c3092fdcb50894ca9f5814b83af816f1d4329368eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c78967ab33419211ed531310b5d40da8b7cfdb4573099d8e1b38b940c75d7a24"
    sha256 cellar: :any_skip_relocation, monterey:       "4de1e88f3b9f6477a154a6f5e946a7411a5a30a4e054d3fac9ad9b62d5964b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "665d2709804555227ee9fdffdf918574902345547bec837c53cd06fff04212c9"
    sha256 cellar: :any_skip_relocation, catalina:       "b3fb2df4df96602895a40900d682fa42ca9bbbc814463eeccd50ddc2cae8f485"
    sha256 cellar: :any_skip_relocation, mojave:         "af978b05395618b4e095498b3a9a4aa66086f8bc793804fb59086177535c8565"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/Swatto/td").install buildpath.children
    cd "src/github.com/Swatto/td" do
      system "go", "install"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/".todos").write "[]\n"
    system "#{bin}/td", "a", "todo of test"
    todos = (testpath/".todos").read
    assert_match "todo of test", todos
    assert_match "pending", todos
  end
end

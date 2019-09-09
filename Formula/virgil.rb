class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.1",
     :revision => "b914b8a6bd707f220a83656e8c8e4c3995300417"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87ca8d26971b5a31df2e6ff9a7f281c0d863d9fd0a4eafb5a2ce28bb1122e26a" => :mojave
    sha256 "181b88ed03e6f35b9d94204e8835a06dce6ef133c90889f7808d99dfbb574ce1" => :high_sierra
    sha256 "86b8ee43bb54eed6922337ce205bf3d734a53cdb85e70951e6e789317c18d8bd" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/VirgilSecurity/virgil-cli"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "virgil"
      bin.install "virgil"
    end
  end

  test do
    result = shell_output "#{bin}/virgil pure keygen"
    assert_match /SK.1./, result
  end
end

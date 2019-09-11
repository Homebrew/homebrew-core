class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.2",
     :revision => "c5cc5011b753a7149c7003f9c041e430d59b6efd"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "733507479075cd10daff920074a761b8521d006c112ee1706b4d1f08f1655e3c" => :mojave
    sha256 "dce39bf7b99b204ccd9722e1756e7c7c6814969ddcbc6046f19d43daf12d6861" => :high_sierra
    sha256 "037bb056392f96e1690d04f644818dbcdf983000062bfc02abe1088abf5efab3" => :sierra
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

class Rome < Formula
  desc "Carthage cache for S3, Minio, Ceph, Google Storage, Artifactory and many others"
  homepage "https://github.com/tmspzz/Rome/#readme"
  url "https://github.com/tmspzz/Rome/archive/refs/tags/v0.24.0.65.tar.gz"
  sha256 "7aee4de208a78208559d6a9ad17788d70f62cace4ff2435b3e817a3e03efdef6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c0cf36af6dfeb99b33b910bf3afbbed3d6dda0ac362be1b8e39dcc690207a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67c36d2034fc1266cb59bf8b853a12dca76166f0366b7b7dbc0d8021922a727c"
    sha256 cellar: :any_skip_relocation, ventura:        "fa13bccb05a85ef64ba51045f2667774ef972a0f5b91f560cc141ed84a4015d0"
    sha256 cellar: :any_skip_relocation, monterey:       "da6813f56ae217251785dedcdb0683b9ce29d4fd124ec9eb43ec1f296f56e663"
    sha256 cellar: :any_skip_relocation, big_sur:        "46ad491ba6f8cd906a93890a4389628ef8b774bd3e4a6174c40d324ba25e72dc"
    sha256 cellar: :any_skip_relocation, catalina:       "135212529c003247ae4ac695a19e5658ae704ee1c1c0dc8131d6b776fa163233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a60357d041aa0c5547afc0cd0ea6bc9d2933d0db3ce3bfaeb6607c9b664f0e4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.10" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"Romefile").write <<~EOS
      cache:
        local: ~/Library/Caches/Rome
    EOS
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "add", "Romefile"
    system "git", "commit", "-m", "test"
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "realm-swift v10.20.2", shell_output("rome list")
  end
end

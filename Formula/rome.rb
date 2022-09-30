class Rome < Formula
  desc "Carthage cache for S3, Minio, Ceph, Google Storage, Artifactory and many others"
  homepage "https://github.com/tmspzz/Rome/#readme"
  url "https://github.com/tmspzz/Rome/archive/refs/tags/v0.24.0.65.tar.gz"
  sha256 "7aee4de208a78208559d6a9ad17788d70f62cace4ff2435b3e817a3e03efdef6"
  license "MIT"

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

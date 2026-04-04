class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "a14d9fa44fe87cd81036b7c883d6cbbd5e500a35d4a055b361a14206cf8ee30d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eceec636ff7a2d458b4d79da03a91fee0770b508f6648b7f883af1ddb3746129"
    sha256 cellar: :any,                 arm64_sequoia: "40910a82ac889bbbb55d1256320bde5ead28fe5c283a51e8d231d851fc77178b"
    sha256 cellar: :any,                 arm64_sonoma:  "ca6fa2e3736a591f6ed8efe5006193d863ccd7cfbf81dd9236ff7ec9444941d0"
    sha256 cellar: :any,                 sonoma:        "6644792bed6e8bc06c11f010f0a75e55e3a93fd874972d0ef22128db171a6fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "410ddc8af145c75e2ce1729d35e26570ace198cf9e04f47270ae0c5b453e7d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaf1f8a5f910951ed3259eed744978ec65aad0f69ceef9b261056f020860e5c9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end

class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "4004e6b42afdc3cb305ad68eca0402445247025458197fb9be0bcc476d66902b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "becceca0fdea027c1139de0fc31295d3f38678f70e4db0d44de0fdb52256791f"
    sha256 cellar: :any,                 arm64_sequoia: "a41e49f041a3a7217a63ad56e3f94fdb0c04ffaf06750d07e1f3db25a2554052"
    sha256 cellar: :any,                 arm64_sonoma:  "1a9f4099055245c6a039dbc9e87651a70ce4b30d9e065a141967fbdd6f84b755"
    sha256 cellar: :any,                 sonoma:        "708ee543ef53442b4fd436eb32f758317ca26fe49414ecbd70ca59482b592878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f890e12bf5a5d42ac44ed46a7ee4fb633b656cd1e00c5abd1e99010c874129e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec4627581deaa344d0f2a23757727c18b0a236512d8292ed7107eea3d508f8b"
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

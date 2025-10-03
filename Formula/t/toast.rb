class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/refs/tags/v0.47.7.tar.gz"
  sha256 "532a883c0e96ab274c25e3256ad532e525fd2d5e393ebd4712e591de64a2f7c9"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d9f65aeb892f6b89fa305c453c76df57442f044504cafa48098590f55db5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f558594467882fba23da8e01983eac6efd36eb830be012f702967b3caf4fb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce42343f3cc19695a755e28e579cc7937ac70a7ec7e35dc5d0c2cc39e71264ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d5dffeed5b421ec1253333fe7e621cc590cf8606d2880400d6500a577e03b2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a20c9c83d5f0bbef1ae0b0157f7a2adfcdce1251e649c53c78295123352604"
    sha256 cellar: :any_skip_relocation, ventura:       "2361a75dc4e6f9bbc4ee54b983b5575f5ad60b50dc941702274d8f163afbd0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a83e8715ac42e645ef9edfefb127d454eb2bbee2c2f791d466a68da876dcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed0686a150d2936eb37bb83197d2e55088533f73af946df1261a58ced8cddc6"
  end

  depends_on "rust" => :build

  conflicts_with "libgsm", because: "both install `toast` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~YAML
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    YAML

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end

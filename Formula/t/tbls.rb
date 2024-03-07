class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.73.2.tar.gz"
  sha256 "d916ec86ad41d437465d8dca352c3db809c64d14ce78077558a0ab61a11260d1"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a813069c3882289c5b8666528cb01f46d57c882baefaeb8ad894b1de20506ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e67dc515db53fc766d7c7f38f4fa1189661f6ccd8b27fbba7d4e949695178faf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f4de5f311d6d7b792c730c03d93102802e8fc953f0355aba5bd210d42c13613"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ebfc6b66e5865ce5be4d42d50622c85c41f2f50f07a5bf7ce4aea6b3df8dc09"
    sha256 cellar: :any_skip_relocation, ventura:        "8c88ed51889030cad91b0d245adf63f6ad50eaad24fbe174959ca79942875fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "1818574b716c2427e64cda8a3a42b19b5456014cc3e42933a510a20f4403cf58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bab01b6a952544f0cc1b29b3ea6e5ddd54741e568122626164e36306ab1237"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end

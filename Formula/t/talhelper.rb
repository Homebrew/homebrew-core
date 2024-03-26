class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "5cc1cd7117eb7530e1735419022c9d9dc7eb07b0da6d8cb6feb6e97daf8db55b"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2de5a23e9b6ad9fefaf16ccdcbd83628da4460d45e86f641453be51bb99886b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "192b283c0773468db2ac9f898826197b68f3a56b89b27a8535a477674b3d5959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ba1543a7e142cd1b358640fb7dbd4e4f5df3c9db53d6e94e9febaba74289d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f02a11c3915843eb86a37c25dddbf060e5bced2eab27a60018e385a967f53c2"
    sha256 cellar: :any_skip_relocation, ventura:        "35c285efbd55152ac360d202f1c8e7f2415159a27090f8b5c98ab4059e0e2ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "1d172dcf5a2018db981e2fac0e842c164663a06466dfa100b73afec0726646c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4e5f1b8951285373a043e3fcbf8727c8883d0750f8e2340701b91c222830f1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end

class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "4884df906a5c2b9b3bc09482c83f2eb61dbc2a3effc91a55e1eae1b7def7a806"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b249381c0c93ec5f3946bbbdb1c904c46b4dd384e53010b23094491f6acde279"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ae90988072ed235a98b703285da33084772e8a30b87bcca6cde624546949fa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009be4a5a72aed1db01ccaf3ca4e665572d7dc241c9705d4a1099106a06fdf08"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fc3c778e22c076e5a5b893696b1f7bd71e7c77d54a44c7a2d45c76db23f9831"
    sha256 cellar: :any_skip_relocation, ventura:        "636c260144999cc92c572704716d842a70a0b9600c3d69571b13876828622a6a"
    sha256 cellar: :any_skip_relocation, monterey:       "0aab36447dcf2bae8d23b85e562363b17fa947eb5fff3f418b325bc82fefc2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a76099418d8c9332f314f25bf408e97b8524894acac32d7252c8a7702485acd"
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

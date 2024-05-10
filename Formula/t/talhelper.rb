class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "7dc6962fe2f355e4929453c1bcbd41e8c340785410c724f85a297ecda441e095"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1220948c558d652ba6ddda39b4ce5ad70237effa946a15dac601b8b3edb1043"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971a349bfcc0d24c295f9386c79fea23267230f7702199d167e0fc4bb27072dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13627d0e8ed2f0fc71e4c99b33aa5b5cb1dcc6f5b5d20e8bcab16f9e166d2034"
    sha256 cellar: :any_skip_relocation, sonoma:         "809cf394e4db14ae5d8262a9c33d871ec70370f64a932826ee7015d96045396c"
    sha256 cellar: :any_skip_relocation, ventura:        "5a5b5b47439a7acea31ac2889e67f99ffac61189b3a5fbcbcb517e4d48dd27f2"
    sha256 cellar: :any_skip_relocation, monterey:       "89456c9b38705113c3bee4005f02c5535dd9619f9a44b6f75135e9ae5c569266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e1090c3cf9ee15aedaa6a69f3600ddb490d6007ff584e24edc3adb2f10cf38"
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

class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.30.tar.gz"
  sha256 "043156c1dd079230e95ba481b034c9686e48b43d6c4602510a73843c80b3484d"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b98be976696657183b5afeb6f1fa1079ac673b3e08a65f629dc98d4996e270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b98be976696657183b5afeb6f1fa1079ac673b3e08a65f629dc98d4996e270"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44b98be976696657183b5afeb6f1fa1079ac673b3e08a65f629dc98d4996e270"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc00e9af96dfeb41370ef82ba80d37366462ef3e204a8ed6f7b9be1cc8525725"
    sha256 cellar: :any_skip_relocation, ventura:       "dc00e9af96dfeb41370ef82ba80d37366462ef3e204a8ed6f7b9be1cc8525725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45a8db8181ddd0144265699ff960b8eb529e0fa97ded11e8847eddb5a59ae5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
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

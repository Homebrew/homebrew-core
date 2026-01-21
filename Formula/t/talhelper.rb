class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "d24f73e10f227047e12fb16aa69f72fb3bd5718aceced145744440bb45b13dcb"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e0815969493c70f3142f0d5bce26cb610a80f255e09db8641d2f954e74f9ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e0815969493c70f3142f0d5bce26cb610a80f255e09db8641d2f954e74f9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e0815969493c70f3142f0d5bce26cb610a80f255e09db8641d2f954e74f9ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "3536bb94286ebb49470742e46c3225994007fe2dc21f728627ec3aaa9067597e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "797ed6222d1259404a6b3ce4a7ca3fdd3ce68adf2addd49f8986643c5e1c3f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1285fd452294f21827310db3f1527213f65eab8e7074fffda4c2a02cab5d6d6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
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

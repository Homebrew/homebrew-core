class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.2",
      revision: "8c37a9df22f2f64ba10f71247cc8bcdf95f4ff51"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2ceb38bbed2c8533410d009fb8afbe78fb30ee6b14d89d599f8693cbf9a6ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1404551107799054401d4b96faa2c0a76b62d80105f043599709436b170ba441"
    sha256 cellar: :any_skip_relocation, monterey:       "39a30e74c8a1beef952eba22a4190e4b07f58bfd5d8401e1fe4c55142c1cd32c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8bf890d06464fdb789a7a9d401cf520d5130550c581c135c3ae00936d522a81"
    sha256 cellar: :any_skip_relocation, catalina:       "903d174983c3a2fb1442739f7fc5215d8e959adedff9b0c0e1a952893143a5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3abd5c1b873972e6cddd992f7a01bba3bef12e33bf5135a999cd2046faebcca1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo: var
    EOS

    (testpath/".teller.yml").write <<~EOS
      project: brewtest

      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          env_sync:
            path: #{testpath}/test.env
    EOS

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show")
    assert_match "teller: loaded variables for brewtest using #{testpath}/.teller.yml", output
    assert_match "foo", output

    assert_match "Teller #{version}", shell_output("#{bin}/teller version")
  end
end

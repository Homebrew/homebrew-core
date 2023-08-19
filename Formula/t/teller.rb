class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.6",
      revision: "7b714bc2f1d5e14920f2add828fdf7425148ff6b"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6efc5ee36a0fb0d5a6c3bf9bd34424e8fa297a328e5ff3d590863521b4b5d0c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "880fe24f3d79c196a20b850452274728a9cb135cb0bf19ee1e0888b9025cbf00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c82814b0c169afe96b4315b8a18a95881129c44d607c9a3185f38caba8fb7f71"
    sha256 cellar: :any_skip_relocation, ventura:        "d425c61cf4358c7c2ff451c1c3b6161ad67bcef64aa19401201789be98d198fc"
    sha256 cellar: :any_skip_relocation, monterey:       "c95785a51067a6ed798e7a41787bb00d7cf5747bb0a3559e9f7df9442de756db"
    sha256 cellar: :any_skip_relocation, big_sur:        "04987c4db227ef8fab1288ee03506684c4e49f72d73f06c4035c858cea21b72d"
    sha256 cellar: :any_skip_relocation, catalina:       "86656bbfd93625dac6daa93ecfaba265c3113a5f00bd4ed811f39aa80c445be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234ad493942bf3d5d2b93ff1114dfebf5280a0325c1b6271a7e2b22306a02067"
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

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show  2>&1")
    assert_match "teller: loaded variables for brewtest using #{testpath}/.teller.yml", output
    assert_match "foo", output

    assert_match "Teller #{version}", shell_output("#{bin}/teller version")
  end
end

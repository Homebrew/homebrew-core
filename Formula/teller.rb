class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.0",
      revision: "31ba0815a8da8605696a093c556d9a552310caf2"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d292bea2d463855fcc14aa61113e9f77a66a92948c3aa1c226936626c01936e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d648ff54ffb1f1e89803fde38ff2a9ca9e441354c6564a4759a0e0d204eaf896"
    sha256 cellar: :any_skip_relocation, monterey:       "58e90773ae75d960e18a38c0db60b370003097e5ce40742c3c4fda86ec7ca8f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "75aaa2717dcfc08c7c385f90f2b753963830cf0ab0dd210f3bb04a53bce52f2f"
    sha256 cellar: :any_skip_relocation, catalina:       "8262940b764ae65f67db4025ab42e8f09ad599541fb4add01068863ab803c3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b739f00841c09d4525d38837e79dc7ebd466edfa66ec5b8ef6b87d6c57d88089"
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

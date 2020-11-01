class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v0.10.2-1.tar.gz"
  sha256 "a3c855cef9aae00f28c9b39d70d1df0c94e965a389ae38c4dd0d5b07a5fea6bc"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "56023b2b4652e0354075acfb10548bff506fcd296e9414473abca8829116b049" => :catalina
    sha256 "98ab12c9dea3d6601231c35be6e2e24f0cca7351d6c86760307d56f9d5767434" => :mojave
    sha256 "d7abe54bc7455e0ca5547ccd09afded852f4ce30721aebbd28136919cbe885f5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: ok", shell_output("#{bin}/rain check test.template").strip
  end
end

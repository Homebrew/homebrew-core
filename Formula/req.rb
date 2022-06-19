class Req < Formula
  desc "Simple and opinionated HTTP scripting language"
  homepage "https://github.com/andrewpillar/req"
  url "https://github.com/andrewpillar/req/archive/v1.1.0.tar.gz"
  sha256 "4b628556876a5d16e05bdcca8b9a0e9147d48d801e49b0acc624adf6cb4e5350"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.req").write <<~EOS
      Stderr = open "/dev/stderr";
      Endpoint = "https://api.github.com/users";
      Resp = GET "$(Endpoint)/defunkt" -> send;
      match $Resp.StatusCode {
          200 -> {
              User = decode json $Resp.Body;
              writeln _ "Got user: $(User["login"])";
          }
          _   -> {
              writeln $Stderr "Unexpected response: $(Resp.Status)";
              exit 1;
          }
      }
    EOS
    assert_match "Got user: defunkt", shell_output("#{bin}/req test.req")
  end
end

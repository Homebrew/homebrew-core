class Req < Formula
  desc "Simple and opinionated HTTP scripting language"
  homepage "https://github.com/andrewpillar/req"
  url "https://github.com/andrewpillar/req/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4b628556876a5d16e05bdcca8b9a0e9147d48d801e49b0acc624adf6cb4e5350"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "16f15db092a3128344c2731a6294b92c13ac3f1a9a2578333127c40862c24169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "80b342c2fd081a819943fe63fd72a9c3b2e53ffa78ca8d34b45b841f9120910e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af8452502e589a8191f0c752198d5e9167188cee8314310ecaa24adcb12f7445"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761e455eaec2c41951b0aef7e6ccea876443742d59c630ad922b0a0a6eac7204"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b469cb7417b2afa5e405cea18a5d0d2772b9e59cd986ed69b1e1ae1e1fb66f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "279b79fce25a2ffa89d62d35116f3a9bd0e4a0f842d67ba805549881b18ae084"
    sha256 cellar: :any_skip_relocation, sonoma:         "8896fd67fc6bd2d72c653bcd2611d1cb561c6fbf46a8a80e0439c50d6a512da1"
    sha256 cellar: :any_skip_relocation, ventura:        "f456775fc061aa0e0f3d864a014aae9c43c68a7eda55f5b73915a5daa788abf7"
    sha256 cellar: :any_skip_relocation, monterey:       "dbc6285c19cd5b0564bf5f2fb3a06023b96793ed139984aeadfaa8aa1c1f4181"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc965d02788d551a28e21aff831c60c7cc9ac17197399651fd6a210bd1f0b3b4"
    sha256 cellar: :any_skip_relocation, catalina:       "e4d3f87b52397cf896e418a57719c8cebdd81c97a54eab5559c3606e0f91bbe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4459ae7f23e6236b6505f02322ba53e9a78a6c0a87b02b98236de6a32fff83d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235b2a9a3aa0e458c04d7c4d77fc8bfbb7951c98bedbe5e4d1f7263609e964a2"
  end

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


class Torxakis < Formula
  desc "Tool for Model Based Testing"
  homepage "https://github.com/TorXakis/TorXakis"
  url "https://github.com/TorXakis/TorXakis/archive/v0.5.0.tar.gz"
  sha256 "03b370d2145206769e6cd12935404c5235a2afa6a779aef0aa3d0030057c6375"
  head "https://github.com/TorXakis/TorXakis.git"

  depends_on "haskell-stack" => :build
  depends_on "z3" => :run

  def install
    ohai "running install"
    jobs = ENV.make_jobs
    ENV.deparallelize
    system "stack", "-j#{jobs}", "--stack-yaml=stack_linux.yaml", "setup"
    system "stack", "-j#{jobs}", "--stack-yaml=stack_linux.yaml", "--local-bin-path=#{bin}", "install"
    prefix.install "examps"
    prefix.install "docs"
  end

  test do
    ohai "running basic test"
    output_torxakis = pipe_output('printf "eval 33+7777777777777\nq" |torxakis  2>&1')
    assert_match(/7777777777810/, output_torxakis, 'torxakis failed in doing "eval 33+7777777777777"')
    ohai "test succesfull"
  end
end

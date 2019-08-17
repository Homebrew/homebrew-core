
class Torxakis < Formula
  desc "Tool for Model Based Testing"
  homepage "https://github.com/TorXakis/TorXakis"
  url "https://github.com/TorXakis/TorXakis/archive/v0.8.1.tar.gz"
  sha256 "72079ddb7ca4a6ea6132141de4d19ba88b9b6c1c326aca228a6086f938f19b22"
  head "https://github.com/TorXakis/TorXakis.git"

  depends_on "haskell-stack" => :build
  depends_on "z3"


  def install
    ohai "running install"
    jobs = ENV.make_jobs
    ENV.deparallelize

    # next line is only needed for v0.8.1 to patch a mistake in the stack yaml
    # file; after this release it was already fixed in the Torxakis repository
    # So for future recipes the next line may be removed.
    system "sed", "-i", "-e", "s/^- location: /- /", "stack_linux.yaml"
    
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

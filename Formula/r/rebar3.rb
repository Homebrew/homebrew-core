class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.25.1.tar.gz"
  sha256 "458d6ceaf7822dd7682288354ab3ba74e14b3ed11cc5b551af9eb312de894106"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aebec9fe1982491daae78a116accfed673ab509c7b91168c048264b7516a03d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ddc64334491a6041c62359f0071023f05c70165aa57d221a1924f378f932541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b730f3c3eb084553b25e1fa3335188c31f6a41289057bab6715478c6f8ce799"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0349d3cde36fc0aa4e93a1ba35ab9a6ea44d8e526bb88f9cd4bd8aff7865896"
    sha256 cellar: :any_skip_relocation, sonoma:        "00743ddb3ff230137c07049b4e837ca34065ec65156ab654e05f69107115e973"
    sha256 cellar: :any_skip_relocation, ventura:       "d9e245b9abc51ba4ec06e7d9b803bbaf638cec0e9a087482261d38d4f418cd18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d230caab68a05bab0f6b2ad7635e3f0c20f87cb5458791d9c584a0bb4e07c03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b391ea3eceb1883cb2ec84a9b94b2803f9991cf2344d4672fdd7cd5bdaafa41"
  end

  depends_on "erlang@26" => [:build, :test]
  depends_on "erlang"

  def install
    erlang_build_dep = deps.find { |dep| dep.build? && dep.name.match?(/^erlang@\d+$/) }&.to_formula
    odie "Could not find build-time erlang!" if erlang_build_dep.blank?

    # To guarantee compatibility with various erlang versions, build with an older erlang.
    # We want to use `erlang@#{x-2}` where x is the major version of the `erlang` formula.
    build_erlang_version = erlang_build_dep.version.major.to_i
    wanted_erlang_version = Formula["erlang"].version.major.to_i - 2
    if wanted_erlang_version != build_erlang_version
      odie "This formula should be built with `erlang@#{wanted_erlang_version}`"
    end

    # Ensure we're building with versioned `erlang`
    ENV.remove "PATH", "#{Formula["erlang"].opt_bin}:"
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    deps.each do |dep|
      next unless dep.name.match?(/^erlang(@\d+)?$/)

      erlang = dep.to_formula
      erlang_bin = erlang.opt_bin
      erlang_version = erlang.version.major
      with_env(PATH: "#{erlang_bin}:#{ENV["PATH"]}") do
        assert_match "OTP #{erlang_version}", shell_output("#{bin}/rebar3 --version")
      end
    end
  end
end

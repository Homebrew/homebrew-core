class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.27.0.tar.gz"
  sha256 "985cae6e957334cfa549190b9f5efb9185c184a18fc181c87b8dde096ba79f38"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94b3bd9f293d74e1dc1b73bfc720da505e1231e47a37dc16dcc0692a42841361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee39f3c79763195428824f9321846d9f06d87eeb55bb61e2fe8abbe28e7b046a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceaf0897426411e3ca0d2d9b813c5a00b6258a3a79f0f6db5310102c317b09eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0530db6336388349156d54bd48dc901762e9e2400f3451672c06e5760fd6a79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085765e94871855b1b5234c97cf96deadb21fe3b34635e32f1310e40c0d70fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959e9d042c97cb228e137556169daa64f8c8823a8127a0f0123db68f876eabfe"
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

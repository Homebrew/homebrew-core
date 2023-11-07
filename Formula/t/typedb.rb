class Typedb < Formula
  desc "Polymorphic database powered by types"
  homepage "https://typedb.com/"
  url "https://github.com/vaticle/typedb/archive/refs/tags/2.25.0.tar.gz"
  sha256 "0f7c73db6c04cd8f2dbde0dca8ef0afa08a7719b7918f45859eb14c47f3e699e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "0e0ee872bc3e580c2c123ffc92410e740df0326716f27068170289c5df11ac29"
    sha256 cellar: :any_skip_relocation, sonoma:       "0e0ee872bc3e580c2c123ffc92410e740df0326716f27068170289c5df11ac29"
    sha256 cellar: :any_skip_relocation, all:          "0e0ee872bc3e580c2c123ffc92410e740df0326716f27068170289c5df11ac29"
  end

  depends_on "bazelisk" => :build
  depends_on "openjdk"

  uses_from_macos "python" => :build

  def install
    if OS.mac?
      os = "mac"
      ext = "zip"
      target_ext = "zip"
    else
      os = "linux"
      ext = "tar.gz"
      target_ext = "targz"
    end

    arch = if Hardware::CPU.arm?
      "arm64"
    else
      "x86_64"
    end

    target = "//:assemble-#{os}-#{arch}-#{target_ext}"
    archive = "typedb-all-#{os}-#{arch}.#{ext}"

    # Make sure bazel uses the correct cc
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    if OS.linux?
      pyver = Language::Python.major_minor_version "python3.11"
      env_path = "#{Formula["python@#{pyver}"].opt_libexec}/bin:#{env_path}"
    end
    bazel_args = %W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --define version=#{version}
      --verbose_failures
      --action_env=PATH=#{env_path}
      --action_env=JAVA_HOME=#{Formula["openjdk"].opt_prefix}
      --host_action_env=PATH=#{env_path}
      --host_action_env=JAVA_HOME=#{Formula["openjdk"].opt_prefix}
    ]

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *bazel_args, target

    if OS.mac?
      system "unzip", "bazel-bin/#{archive}"
    else
      system "tar", "-xzf", "bazel-bin/#{archive}"
    end

    libexec.install Dir["typedb-all-#{os}-#{arch}-#{version}/*"]
    mkdir_p var/"typedb/data"
    inreplace libexec/"server/conf/config.yml", "server/data", var/"typedb/data"
    mkdir_p var/"typedb/logs"
    inreplace libexec/"server/conf/config.yml", "server/logs", var/"typedb/logs"
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
  end

  test do
    assert_match "THE POLYMORPHIC DATABASE", shell_output("#{bin}/typedb server --help")
  end
end

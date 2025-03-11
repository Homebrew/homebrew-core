class TextGenerationInference < Formula
  include Language::Python::Virtualenv

  desc "Large Language Model Text Generation Inference"
  homepage "https://hf.co/docs/text-generation-inference"
  url "https://github.com/huggingface/text-generation-inference/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "5d67c581fa5af71bfdd7b57e24f36b559a50e3c8472597432b27cc1a1d45b03d"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "uv" => :build
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "python@3.13"

  on_macos do
    depends_on arch: :arm64
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    venv = virtualenv_create(libexec, "python3.13", system_site_packages: false)
    ENV["VIRTUAL_ENV"] = venv.root

    system "cargo", "install", *std_cargo_args(path: "backends/v3", root: libexec)
    system "cargo", "install", *std_cargo_args(path: "launcher", root: libexec)

    %w[text-generation-router text-generation-launcher].each do |name|
      (bin/name).write_env_script(libexec/"bin"/name, PYTHONPATH: venv.site_packages)
    end

    # Prevent error with outlines installation due to location of uv cache
    rm "Cargo.toml"

    uv = Formula["uv"].opt_bin/"uv"
    cd "server" do
      system uv, "run", "--active", "--extra", "gen", "--no-binary-package", "safetensors",
                 "--", "make", "gen-server-raw"
      system uv, "pip", "install", ".[accelerate,compressed-tensors,quantize,peft,outlines]"
    end
    bin.install_symlink libexec/"bin/text-generation-server"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      exec bin/"text-generation-launcher", "-p", port.to_s, "--model-id", "openai-community/gpt2"
    end

    data = "{\"inputs\":\"What is Deep Learning?\",\"parameters\":{\"max_new_tokens\":20}}}"
    header = "Content-Type: application/json"
    retries = "--retry 10 --retry-connrefused"
    output = shell_output("curl -s 127.0.0.1:#{port}/generate_stream -X POST -d '#{data}' -H '#{header}' #{retries}")
    assert_match "generated_text", output
  end
end

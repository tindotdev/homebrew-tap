class DictateCli < Formula
  desc "One-shot CLI for dictate: record, transcribe, and copy to clipboard"
  homepage "https://github.com/tindotdev/dictate"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.5.0/dictate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8f5ffa8b94d3561dbbd31cf2378446437be8e86434433c0ecc89ecf64b5da094"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.5.0/dictate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f5b0a9468d34da94cb7daa57ee7e042d820f2be723d9708aa10a599cf469dc4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.5.0/dictate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3fc4f655bd97dcf6471a43074e694d2326b58928ec003ea1c3e836797556c4c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.5.0/dictate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf50ecefabfcf4d5f848515d0525d32a33510ee4f083fb7d8c7138929a26ac3d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dictate" if OS.mac? && Hardware::CPU.arm?
    bin.install "dictate" if OS.mac? && Hardware::CPU.intel?
    bin.install "dictate" if OS.linux? && Hardware::CPU.arm?
    bin.install "dictate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

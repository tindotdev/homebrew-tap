class DictateCli < Formula
  desc "One-shot CLI for dictate: record, transcribe, and copy to clipboard"
  homepage "https://github.com/tindotdev/dictate"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.6.0/dictate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "69d84585149c67c52c83f31b5daed38cb27624bb87907d830d73475cc47a03f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.6.0/dictate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "730ac6260aa9284918710ee30d4a58e6ca21d354045c3a9021ca56a06aa7edec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tindotdev/dictate/releases/download/v1.6.0/dictate-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0494c024126c6c403249625d6c3ec874006ee3b6afc5ef2255d7536a5bbcba42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tindotdev/dictate/releases/download/v1.6.0/dictate-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51384f7b6abf7afa418bac554a5ad0763aa98a60580a414d05e66debebb60a2f"
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

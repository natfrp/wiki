<template>
	{{ result }}
</template>

<script setup lang="ts">
import { toRefs } from 'vue';

const props = defineProps({
	seed: {
		type: String,
		default: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*'
	},
	length: {
		type: Number,
		default: 24
	}
});
const { seed, length } = toRefs(props);

let result = '';
const characters = seed.value;
if (window.crypto?.getRandomValues !== undefined) {
	const rng = new Uint8Array(length.value);
	window.crypto.getRandomValues(rng);
	for (const r of rng) {
		result += characters.charAt(Math.floor((r / 0xFF) * characters.length));
	}
} else {
	for (let i = 0; i < length.value; i++) {
		result += characters.charAt(Math.floor(Math.random() * characters.length));
	}
}
</script>

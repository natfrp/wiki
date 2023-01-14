<template>
	{{ result }}
</template>

<script setup lang="ts">
import { toRefs } from 'vue';
import crypto from 'crypto';

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

if (import.meta.env.SSR) {
	for (const r of crypto.randomBytes(length.value)) {
		result += characters.charAt(Math.floor((r / 0xFF) * characters.length));
	}
} else {
	for (let i = 0; i < length.value; i++) {
		result += characters.charAt(Math.floor(Math.random() * characters.length));
	}
}
</script>
